#!/usr/bin/env python3
"""Build a small, signed flat APT feed. Never copy the signing home to output."""
import argparse
import datetime
import gzip
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

NAME = "hackberrypi-battery-dkms"
FINGERPRINT = "144BF02265C630AE270F1E88D2BC5DB0662CBD6E"


def run(*args, cwd=None):
    return subprocess.check_output(args, cwd=cwd)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--package", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--gnupghome", type=Path, required=True)
    parser.add_argument("--key", default=FINGERPRINT)
    args = parser.parse_args()
    package, output, signing = (p.resolve() for p in (args.package, args.output, args.gnupghome))
    assert package.is_file() and not package.is_symlink()
    assert signing.is_dir() and not signing.is_relative_to(output)
    assert signing.stat().st_mode & 0o077 == 0, "Signing home must be private (0700)."
    assert args.key == FINGERPRINT, "Key rotation requires an explicit reviewed source change."
    assert run("dpkg-deb", "-f", str(package), "Package").decode().strip() == NAME
    assert run("dpkg-deb", "-f", str(package), "Architecture").decode().strip() == "all"
    version = run("dpkg-deb", "-f", str(package), "Version").decode().strip()
    output.mkdir(parents=True, exist_ok=True)
    assert not output.is_symlink()
    with tempfile.TemporaryDirectory(prefix="battery-feed-") as temp:
        stage = Path(temp)
        shutil.copyfile(package, stage / package.name)
        packages = run("dpkg-scanpackages", "--multiversion", ".", "/dev/null", cwd=stage)
        assert packages.count(b"Package: ") == 1
        (stage / "Packages").write_bytes(packages)
        with (stage / "Packages.gz").open("wb") as target:
            with gzip.GzipFile(filename="", mode="wb", fileobj=target, mtime=0) as gz:
                gz.write(packages)
        now = datetime.datetime.now(datetime.timezone.utc)
        fields = [
            "Origin: HackberryPiBattery",
            "Label: HackberryPiBattery",
            "Suite: stable",
            "Codename: hackberrypi-battery",
            "Architectures: arm64",
            "Description: MAX17048 battery DKMS driver for HackberryPi CM5 Raspberry Pi OS",
            "Date: " + now.strftime("%a, %d %b %Y %H:%M:%S +0000"),
        ]
        for algorithm, label in (("md5", "MD5Sum"), ("sha256", "SHA256"), ("sha512", "SHA512")):
            fields.append(label + ":")
            for name in ("Packages", "Packages.gz"):
                data = (stage / name).read_bytes()
                fields.append(f" {hashlib.new(algorithm, data).hexdigest()} {len(data):16d} {name}")
        (stage / "Release").write_text("\n".join(fields) + "\n")
        gpg = ("gpg", "--homedir", str(signing), "--batch", "--yes", "--local-user", args.key,
               "--digest-algo", "SHA256")
        run(*gpg, "--clearsign", "--output", str(stage / "InRelease"), str(stage / "Release"))
        run(*gpg, "--detach-sign", "--output", str(stage / "Release.gpg"), str(stage / "Release"))
        (stage / "hackberrypi-battery.gpg").write_bytes(run(*gpg, "--export", args.key))
        (stage / "hackberrypi-battery.asc").write_bytes(run(*gpg, "--armor", "--export", args.key))
        run("gpgv", "--keyring", str(stage / "hackberrypi-battery.gpg"), str(stage / "InRelease"))
        run("gpgv", "--keyring", str(stage / "hackberrypi-battery.gpg"),
            str(stage / "Release.gpg"), str(stage / "Release"))
        staged = sorted(stage.iterdir())
        proof = {
            "passed": True,
            "package": NAME,
            "version": version,
            "signing_fingerprint": args.key,
            "private_signing_material_in_output": False,
            "signature_verification": ["InRelease", "Release.gpg"],
            "files": {p.name: {"bytes": p.stat().st_size,
                                  "sha256": hashlib.sha256(p.read_bytes()).hexdigest()} for p in staged},
        }
        for path in staged:
            shutil.copyfile(path, output / path.name)
        (output.parent / "repository-proof.json").write_text(json.dumps(proof, indent=2) + "\n")
    print(json.dumps({"passed": True, "version": version, "files": len(proof["files"]),
                      "fingerprint": args.key, "output": str(output)}))


if __name__ == "__main__":
    main()
