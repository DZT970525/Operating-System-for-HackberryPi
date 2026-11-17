#!/usr/bin/env python3
"""Fixed, manual, draft-only recovery of four verified RPiOS release files."""
import hashlib
import http.client
import json
import math
import os
from pathlib import Path
import re
import shutil
import ssl
import sys
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request

REPOSITORY='DZT970525/Operating-System-for-HackberryPi'
OWNER='DZT970525'
RELEASE_ID=448817824
RELEASE_TAG='rpios-clash-power-hackberrypi-2026-11-17'
API='https://api.github.com/repos/'+REPOSITORY
MANIFEST_NAME='RPiOS-Transfer-Manifest-20261117-v2.json'
MANIFEST_BYTES=13276
MANIFEST_SHA256='dd01f511b5ad5d62caa17ee807cc2dc6518d8c69f98d164be4e1e58ad82091cc'
CHUNK_BYTES=67108864
STREAM_NAMES={'image':'RPiOS-HackberryPi-CM5-20261117-v2.img.xz',
 'payload03':'hbr_payload_03.tar.gz','payload04':'hbr_payload_04.tar.gz','payload05':'hbr_payload_05.tar.gz'}
# Numeric IDs are bound from a fresh authenticated listing of this exact draft,
# never taken from arbitrary inputs or recovered from redacted browser state.
KNOWN_EMPTY_FAILURE_NAMES={'RPiOS-HackberryPi-CM5-20261117-v2.img.xz','hbr_payload_03.tar.gz'}
EXPECTED_FINAL = {'hbr_boot.tar.gz': {'name': 'hbr_boot.tar.gz', 'bytes': 60077270, 'sha256': '9f779154d3882284e5e3da929c7987eb3777647bc6a78dd8b8fc589db399c8c1'}, 'hbr_root.tar.gz': {'name': 'hbr_root.tar.gz', 'bytes': 524, 'sha256': '392be62526c6ee122a6dd7e771624f6890a45b235ba2c06a263b1e2b255ba6ea'}, 'hbr_payload_01.tar.gz': {'name': 'hbr_payload_01.tar.gz', 'bytes': 519345580, 'sha256': '75bbbb5546e24ee1f9c50f45d2e208e1392a6752133b90bdf8fa32c3c54c5633'}, 'hbr_payload_02.tar.gz': {'name': 'hbr_payload_02.tar.gz', 'bytes': 439357609, 'sha256': '4af03cb3ac2df7f36072c540ad59792e857485f8a9695e44856a5d93a2eea9b8'}, 'hbr_payload_03.tar.gz': {'name': 'hbr_payload_03.tar.gz', 'bytes': 553819511, 'sha256': 'f6a4dca3fce67dfa8a87e551f730d52b5e1d1edf80f274133d5ad6eabb8cab19'}, 'hbr_payload_04.tar.gz': {'name': 'hbr_payload_04.tar.gz', 'bytes': 477574173, 'sha256': 'f60806d472fd343290f1429ccd5e8e7599e0967d905dfbd17e7b2a097e9a07e4'}, 'hbr_payload_05.tar.gz': {'name': 'hbr_payload_05.tar.gz', 'bytes': 84389308, 'sha256': 'db2776908468a9c867639da62afe156287b42e535f7e3927e5b2b74efdd3301a'}, 'partition_setup.sh': {'name': 'partition_setup.sh', 'bytes': 12899, 'sha256': 'b293c2034733e5e03ce81c85b54d56e3c01d201bc163fffbf5148e571cd4b411'}, 'partitions.json': {'name': 'partitions.json', 'bytes': 589, 'sha256': 'cf46bc568a58fae9c13e9a86e7970d443350052b04d97d5d95817c9bb6c255e9'}, 'os.json': {'name': 'os.json', 'bytes': 784, 'sha256': '00da93c2a6f397aa3f76f3354999aa9e9b38158a114e610c5debee75fe1f77f4'}, 'archives.json': {'name': 'archives.json', 'bytes': 2413, 'sha256': '16a66e3c914d853535042db85a8dade5e1b54f4209b509ab8e402b64babc3aba'}, 'os_list_v3.json': {'name': 'os_list_v3.json', 'bytes': 1768, 'sha256': 'e964acc03a4fd2d2b9edb283ba441558d76c1429d2308702949b64793ce29755'}, 'RPiOS-HackberryPi-PINN-Source-20261117-v2.tar.xz': {'name': 'RPiOS-HackberryPi-PINN-Source-20261117-v2.tar.xz', 'bytes': 60324, 'sha256': '695f2632230a367998c86db6688c5083526864998f943349e1f2a2d94facf2cc'}, 'PINN-SHA256SUMS': {'name': 'PINN-SHA256SUMS', 'bytes': 1220, 'sha256': 'aea7176069efd0061ea6ec91e7f289bf6bc62341542a1d8943dfa2ee91732f78'}, 'PINN-ASSEMBLY-VERIFICATION.json': {'name': 'PINN-ASSEMBLY-VERIFICATION.json', 'bytes': 677, 'sha256': 'ebc9884992865a8bd447b16dface7b3f6698ce07a7dc5a725a96308eddeac42d'}, 'RPiOS-HackberryPi-CM5-20261117-v2.img.xz': {'name': 'RPiOS-HackberryPi-CM5-20261117-v2.img.xz', 'bytes': 1762440812, 'sha256': '89f8ca2bb1a4c741cb67af8d3a629fd76cf71109e50d59ebffdd6e83399e75fa'}, 'image-verification.json': {'name': 'image-verification.json', 'bytes': 4906, 'sha256': '232d0e78981500c204e493123bfb4992d293bf7578789551750580f74cbb32e8'}, 'kernel-upgrade-verification.json': {'name': 'kernel-upgrade-verification.json', 'bytes': 3170, 'sha256': '2a24d25392e13f6e3657f2e469fb448cdf01a975ec747ae9135fe42b692cce20'}, 'factory-status.json': {'name': 'factory-status.json', 'bytes': 2416, 'sha256': '5e38779bb24bf84ed72b797169d1b204ac1134b886bb60c61ad10aa342a6b840'}, 'image-facts.json': {'name': 'image-facts.json', 'bytes': 702, 'sha256': '0787aa2dea00b57fc386cc1bba950cc3562e037ca243149ac7fc2203b02c5b8f'}, 'SHA256SUMS': {'name': 'SHA256SUMS', 'bytes': 1767, 'sha256': '9228018e31e410a039f358ab2e236b0384b1402a756228361603581ef6cff6fd'}}

class SafeError(RuntimeError):pass
def need(value,message):
    if not value:raise SafeError(message)
def sha(path):
    with Path(path).open('rb') as stream:return hashlib.file_digest(stream,'sha256').hexdigest()
def log(stage,**values):print(json.dumps({'stage':stage,**values},sort_keys=True),flush=True)
def safe_name(name):return isinstance(name,str) and re.fullmatch('[A-Za-z0-9_.+-]+',name)

def ci_guard():
    need(os.environ.get('GITHUB_ACTIONS')=='true','GitHub-hosted workflow required')
    need(os.environ.get('RUNNER_ENVIRONMENT')=='github-hosted','Disposable hosted runner required')
    need(os.environ.get('GITHUB_REPOSITORY')==REPOSITORY,'Wrong repository')
    need(os.environ.get('GITHUB_EVENT_NAME')=='workflow_dispatch' and os.environ.get('GITHUB_REF')=='refs/heads/main','Manual main-only run required')
    need(os.environ.get('GITHUB_ACTOR','').casefold()==OWNER.casefold(),'Repository owner must dispatch this task')
    need(re.fullmatch('[0-9a-f]{40}',os.environ.get('GITHUB_SHA','')),'Pinned checkout commit required')
    need(os.environ.get('HBPI_RECOVERY_MANIFEST_SHA256')==MANIFEST_SHA256,'Workflow manifest pin differs')
    need(os.environ.get('HBPI_RECOVERY_MANIFEST_BYTES')==str(MANIFEST_BYTES),'Workflow manifest length differs')
    need(os.environ.get('HBPI_RECOVERY_HELPER_SHA256')==sha(Path(__file__)),'Reviewed helper hash differs')
    token=os.environ.get('GH_TOKEN','')
    need(10<len(token)<1000 and token.isascii() and all(33<=ord(c)<=126 for c in token),'An ephemeral workflow token is required')
    return token

def release_identity(value):
    need(value.get('id')==RELEASE_ID and value.get('draft') is True,'Fixed target must still be the same private draft')
    need(value.get('author',{}).get('login','').casefold()==OWNER.casefold(),'Draft owner differs')
    need(value.get('url')==API+'/releases/'+str(RELEASE_ID),'Draft API identity differs')
    prefix='https://github.com/'+REPOSITORY+'/releases/tag/'
    html=value.get('html_url','')
    need(isinstance(html,str) and html.startswith(prefix),'Draft HTML identity differs')
    alias=html[len(prefix):]
    need(alias==RELEASE_TAG or re.fullmatch('untagged-[0-9a-f]+',alias),'Untrusted draft alias')
    need(value.get('tag_name') in {RELEASE_TAG,alias},'Draft tag is neither the requested tag nor its freshly derived private alias')
    body=value.get('body','')
    image=EXPECTED_FINAL[STREAM_NAMES['image']]
    image_url='https://github.com/'+REPOSITORY+'/releases/download/'+RELEASE_TAG+'/'+image['name']
    need(isinstance(body,str) and image_url in body and image['sha256'] in body and image['name'] in body,'Draft body no longer identifies this measured image and requested release')
    return alias

def asset_identity(asset,release):
    alias=release_identity(release)
    need(type(asset.get('id')) is int and asset['id']>0,'Invalid asset ID')
    need(asset.get('url')==API+'/releases/assets/'+str(asset['id']),'Asset API identity differs')
    url=asset.get('browser_download_url')
    need(url in {'https://github.com/'+REPOSITORY+'/releases/download/'+tag+'/'+asset['name'] for tag in [RELEASE_TAG,alias]},'Asset alias is not derived from this draft')

def exact(asset,expected,release):
    if not asset:return False
    if not (asset.get('name')==expected['name'] and asset.get('state')=='uploaded'
      and asset.get('size')==expected['bytes'] and asset.get('digest')=='sha256:'+expected['sha256']):return False
    asset_identity(asset,release)
    return True

def empty_starter(asset):
    return asset.get('state')=='starter' and asset.get('size')==0 and asset.get('digest') in (None,'')

def part_base(name,parts):
    if name in parts:return name
    match=re.fullmatch(r'(.+)\.retry([1-9][0-9]?)',name)
    if match and match[1] in parts:return match[1]
    return None

class NoCredentialRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self,request,fp,code,msg,headers,newurl):
        parsed=urllib.parse.urlsplit(newurl)
        need(parsed.scheme=='https' and bool(parsed.hostname),'Non-HTTPS download redirect refused')
        redirected=super().redirect_request(request,fp,code,msg,headers,newurl)
        need(redirected is not None,'Unsupported redirect')
        for collection in [redirected.headers,redirected.unredirected_hdrs]:
            for key in list(collection):
                if key.casefold() in {'authorization','proxy-authorization','cookie'}:del collection[key]
        return redirected

class Client:
    def __init__(self,token):
        self.token=token
        self.context=ssl.create_default_context()
        self.opener=urllib.request.build_opener(urllib.request.ProxyHandler({}),NoCredentialRedirect(),urllib.request.HTTPSHandler(context=self.context))
    def request(self,url,method='GET',binary=False):
        need(url.startswith(API+'/releases/'),'API outside the fixed repository release family')
        headers={'User-Agent':'HackberryPi-Fixed-RPiOS-Recovery','Accept':'application/octet-stream' if binary else 'application/vnd.github+json',
           'X-GitHub-Api-Version':'2022-11-28','Accept-Encoding':'identity','Authorization':'Bearer '+self.token}
        return self.opener.open(urllib.request.Request(url,headers=headers,method=method),timeout=60)
    def get_json(self,url):
        for attempt in range(3):
            try:
                with self.request(url) as response:
                    data=response.read(4*1024**2+1)
                    need(response.status==200 and len(data)<=4*1024**2,'Invalid bounded API response')
                return json.loads(data)
            except urllib.error.HTTPError as error:
                if error.code not in {429,500,502,503,504} or attempt==2:raise SafeError('GitHub metadata request failed with HTTP '+str(error.code)) from None
                time.sleep(2**attempt)
    def snapshot(self):
        release=self.get_json(API+'/releases/'+str(RELEASE_ID));release_identity(release)
        assets={}
        for page in range(1,51):
            rows=self.get_json(API+f'/releases/{RELEASE_ID}/assets?per_page=100&page={page}')
            need(isinstance(rows,list) and len(rows)<=100,'Invalid asset-list page')
            for row in rows:
                name=row.get('name')
                need(safe_name(name) and name not in assets,'Unexpected or duplicate asset name')
                need(type(row.get('id')) is int and row['id']>0 and row.get('url')==API+'/releases/assets/'+str(row['id']),'Asset-list numeric API identity differs')
                assets[name]=row
            if len(rows)<100:return release,assets
        raise SafeError('Asset pagination limit reached')
    def download(self,asset,expected,destination):
        need(asset['size']==expected['bytes'] and asset['digest']=='sha256:'+expected['sha256'],'Unverified download metadata')
        for attempt in range(3):
            if destination.exists():destination.unlink()
            try:
                digest=hashlib.sha256();count=0
                with self.request(API+'/releases/assets/'+str(asset['id']),binary=True) as source,destination.open('xb') as target:
                    need(source.status==200,'Binary asset response was not HTTP 200')
                    while block:=source.read(1024**2):
                        count+=len(block);need(count<=expected['bytes'],'Binary asset exceeded pinned length')
                        target.write(block);digest.update(block)
                    target.flush();os.fsync(target.fileno())
                need(count==expected['bytes'] and digest.hexdigest()==expected['sha256'],'Binary asset length or checksum differs')
                return
            except Exception:
                if destination.exists():destination.unlink()
                if attempt==2:raise SafeError('Verified asset download failed: '+expected['name']) from None
                time.sleep(2**attempt)
    def delete(self,asset):
        with self.request(API+'/releases/assets/'+str(asset['id']),method='DELETE') as response:
            need(response.status==204,'Scoped asset deletion was not confirmed')
    def upload(self,path,expected):
        need(path.stat().st_size==expected['bytes'] and sha(path)==expected['sha256'],'Local whole blob changed before upload')
        url='/repos/'+REPOSITORY+f'/releases/{RELEASE_ID}/assets?name='+urllib.parse.quote(expected['name'],safe='')
        connection=http.client.HTTPSConnection('uploads.github.com',context=self.context,timeout=90)
        try:
            connection.putrequest('POST',url)
            for key,value in {'Authorization':'Bearer '+self.token,'User-Agent':'HackberryPi-Fixed-RPiOS-Recovery',
               'Accept':'application/vnd.github+json','X-GitHub-Api-Version':'2022-11-28',
               'Content-Type':'application/octet-stream','Content-Length':str(expected['bytes'])}.items():connection.putheader(key,value)
            connection.endheaders()
            with path.open('rb') as stream:
                while block:=stream.read(4*1024**2):connection.send(block)
            response=connection.getresponse();response.read(2*1024**2+1)
            need(response.status==201,'Whole-asset upload did not return HTTP 201')
        finally:connection.close()

def validate_manifest(value):
    need(set(value)=={'format_version','repository','release_id','release_tag','chunk_bytes','transport_only','final_assets_unchanged','delete_transport_assets_only_after_all_final_assets_verified','expected_final_assets','streams'},'Manifest fields differ')
    need(value['format_version']==1 and value['repository']==REPOSITORY and value['release_id']==RELEASE_ID and value['release_tag']==RELEASE_TAG and value['chunk_bytes']==CHUNK_BYTES,'Manifest scope differs')
    need(all(value[k] is True for k in ['transport_only','final_assets_unchanged','delete_transport_assets_only_after_all_final_assets_verified']),'Manifest cleanup flags differ')
    rows=value['expected_final_assets'];need(len(rows)==21,'Manifest requires exactly 21 final assets')
    final={}
    for row in rows:
        need(set(row)=={'name','bytes','sha256'} and row['name'] not in final,'Invalid or duplicate final record')
        final[row['name']]=row
    need(final==EXPECTED_FINAL,'Manifest final assets differ from the fixed publication')
    streams=value['streams'];need([s['key'] for s in streams]==list(STREAM_NAMES),'Four ordered stream keys differ')
    parts={}
    for stream in streams:
        need(set(stream)=={'key','name','bytes','sha256','parts'},'Invalid stream fields')
        expected=EXPECTED_FINAL[STREAM_NAMES[stream['key']]]
        need({k:stream[k] for k in ['name','bytes','sha256']}==expected,'Whole stream differs')
        rows=stream['parts'];need(len(rows)==math.ceil(stream['bytes']/CHUNK_BYTES),'Part count differs')
        for number,row in enumerate(rows,1):
            need(set(row)=={'name','bytes','sha256'},'Invalid part fields')
            name=f'rpios-v2-upload-{stream["key"]}.part{number:03d}'
            length=min(CHUNK_BYTES,stream['bytes']-(number-1)*CHUNK_BYTES)
            need(row['name']==name and row['bytes']==length and type(row['bytes']) is int,'Part name or size differs')
            need(re.fullmatch('[0-9a-f]{64}',row['sha256']) and name not in parts,'Invalid part checksum or duplicate part')
            parts[name]=row
    need(len(parts)==46 and sum(s['bytes'] for s in streams)==2878223804,'Transfer totals differ')
    return streams,parts

def inspect(release,assets,parts,require_final=False,approved_failed_ids=None):
    approved_failed_ids=approved_failed_ids or {}
    for name,asset in assets.items():
        if name in EXPECTED_FINAL:
            if exact(asset,EXPECTED_FINAL[name],release):continue
            need(not require_final and name in KNOWN_EMPTY_FAILURE_NAMES and empty_starter(asset)
              and asset['id']==approved_failed_ids.get(name),'A final asset is wrong or is not an approved empty failure')
        elif name==MANIFEST_NAME:
            need(exact(asset,{'name':name,'bytes':MANIFEST_BYTES,'sha256':MANIFEST_SHA256},release),'Transport manifest differs')
        else:
            base=part_base(name,parts);need(base is not None,'An unrelated asset is present; no mutation is allowed')
            expected=dict(parts[base],name=name)
            need(exact(asset,expected,release) or empty_starter(asset),'A nonzero transport part or retry differs')
    for name,expected in EXPECTED_FINAL.items():
        if require_final or name not in STREAM_NAMES.values():need(exact(assets.get(name),expected,release),'A required final asset is absent or differs')

def candidates(release,assets,parts,base):
    matching=[]
    for name,asset in assets.items():
        if part_base(name,parts)==base and exact(asset,dict(parts[base],name=name),release):
            number=0 if name==base else int(name.rsplit('.retry',1)[1]);matching.append((number,asset))
    need(matching,'No verified base or retry is available for part '+base)
    return sorted(matching,key=lambda x:x[0])[0][1]

def main():
    need(len(sys.argv)==1,'This fixed recovery action accepts no command-line arguments')
    client=Client(ci_guard())
    need(isinstance(EXPECTED_FINAL,dict) and len(EXPECTED_FINAL)==21,'Final publication pins are missing')
    release,assets=client.snapshot()
    original_failed={n:a['id'] for n,a in assets.items() if n in KNOWN_EMPTY_FAILURE_NAMES and empty_starter(a)}
    part_names={f'rpios-v2-upload-{key}.part{n:03d}' for key,name in STREAM_NAMES.items() for n in range(1,math.ceil(EXPECTED_FINAL[name]['bytes']/CHUNK_BYTES)+1)}
    all_complete=all(exact(assets.get(n),e,release) for n,e in EXPECTED_FINAL.items())
    if MANIFEST_NAME not in assets:
        need(all_complete and set(assets)==set(EXPECTED_FINAL),'Pinned transport manifest is missing')
        log('already_complete',verified_final_assets=21,transport_assets_remaining=0);return
    manifest_asset=assets[MANIFEST_NAME]
    need(exact(manifest_asset,{'name':MANIFEST_NAME,'bytes':MANIFEST_BYTES,'sha256':MANIFEST_SHA256},release),'Pinned manifest is not uploaded correctly')
    with tempfile.TemporaryDirectory(prefix='hbpi-rpios-recovery-') as directory:
        root=Path(directory);manifest_path=root/'manifest.json'
        client.download(manifest_asset,{'name':MANIFEST_NAME,'bytes':MANIFEST_BYTES,'sha256':MANIFEST_SHA256},manifest_path)
        need(manifest_path.stat().st_size==MANIFEST_BYTES and sha(manifest_path)==MANIFEST_SHA256,'Downloaded manifest differs')
        streams,parts=validate_manifest(json.loads(manifest_path.read_text()))
        need(set(parts)==part_names,'Derived part names differ')
        inspect(release,assets,parts,require_final=all_complete,approved_failed_ids=original_failed)
        plan={'release_id':RELEASE_ID,'release_tag':RELEASE_TAG,'manifest_sha256':MANIFEST_SHA256,
          'approved_empty_failures':[{'name':n,'asset_id':i,'state':'starter','bytes':0} for n,i in sorted(original_failed.items())],
          'whole_target_names':list(STREAM_NAMES.values()),'transport_base_part_count':46,'retry_suffix_range':[1,99]}
        plan_path=root/'fixed-recovery-plan.json';plan_path.write_text(json.dumps(plan,sort_keys=True)+'\n');plan_path.chmod(0o444)
        log('fixed_readonly_recovery_plan',**plan)
        whole={}
        if not all_complete:
            need(shutil.disk_usage(root).free>=2878223804+CHUNK_BYTES+512*1024**2,'Insufficient disposable runner storage')
            for stream in streams:
                destination=root/('whole-'+stream['key']);digest=hashlib.sha256();count=0
                with destination.open('xb') as target:
                    for part in stream['parts']:
                        current_release,current=client.snapshot();inspect(current_release,current,parts,approved_failed_ids=original_failed)
                        selected=candidates(current_release,current,parts,part['name'])
                        temporary=root/'part-download'
                        log('download_part',name=selected['name'])
                        client.download(selected,dict(part,name=selected['name']),temporary)
                        with temporary.open('rb') as source:
                            while block:=source.read(1024**2):target.write(block);digest.update(block);count+=len(block)
                        temporary.unlink()
                    target.flush();os.fsync(target.fileno())
                need(count==stream['bytes'] and digest.hexdigest()==stream['sha256'],'Assembled whole stream differs')
                whole[stream['name']]=destination
            # All four streams must pass, before any DELETE or POST is reachable.
            need(len(whole)==4 and all(p.stat().st_size==EXPECTED_FINAL[n]['bytes'] and sha(p)==EXPECTED_FINAL[n]['sha256'] for n,p in whole.items()),'Complete four-stream verification failed')
            log('all_four_whole_streams_verified',stream_count=4)
            for name,path in whole.items():
                current_release,current=client.snapshot();inspect(current_release,current,parts,approved_failed_ids=original_failed)
                existing=current.get(name)
                if exact(existing,EXPECTED_FINAL[name],current_release):continue
                if existing:
                    need(name in original_failed and existing['id']==original_failed[name]
                         and empty_starter(existing),'Only the fixed initial empty failure may be removed')
                    # Independently re-fetch this exact asset ID and its current
                    # membership immediately before the narrowly scoped DELETE.
                    detail=client.get_json(API+'/releases/assets/'+str(existing['id']))
                    fresh_release,fresh=client.snapshot();inspect(fresh_release,fresh,parts,approved_failed_ids=original_failed)
                    listed=fresh.get(name)
                    need(listed is not None and listed['id']==detail.get('id')==original_failed[name]
                      and detail.get('name')==name and detail.get('url')==API+'/releases/assets/'+str(original_failed[name])
                      and empty_starter(detail) and empty_starter(listed),'The fixed empty failure changed before deletion')
                    client.delete(detail);log('removed_approved_empty_failure',name=name,asset_id=detail['id'])
                current_release,current=client.snapshot();inspect(current_release,current,parts,approved_failed_ids=original_failed)
                need(name not in current,'Target slot changed before upload')
                log('upload_verified_whole',name=name)
                try:client.upload(path,EXPECTED_FINAL[name])
                except Exception:log('upload_response_not_confirmed',name=name)
                for attempt in range(12):
                    current_release,current=client.snapshot()
                    if exact(current.get(name),EXPECTED_FINAL[name],current_release):break
                    if attempt==11:raise SafeError('Whole upload was not server-verified: '+name)
                    time.sleep(5)
        current_release,current=client.snapshot();inspect(current_release,current,parts,require_final=True)
        log('all_final_assets_server_verified',verified_final_assets=21)
        # Manifest goes LAST, so interrupted cleanup can verify remaining aliases.
        disposable=sorted(n for n in current if part_base(n,parts) is not None)+[MANIFEST_NAME]
        pinned_ids={n:current[n]['id'] for n in disposable}
        for name in disposable:
            current_release,current=client.snapshot();inspect(current_release,current,parts,require_final=True)
            asset=current.get(name)
            need(asset is not None and asset['id']==pinned_ids[name],'Temporary asset identity changed during cleanup')
            client.delete(asset);log('removed_verified_transport_asset',name=name,asset_id=asset['id'])
        current_release,current=client.snapshot();inspect(current_release,current,parts,require_final=True)
        need(set(current)==set(EXPECTED_FINAL),'Temporary assets remain after cleanup')
        log('recovery_complete',verified_final_assets=21,deleted_transport_assets=len(disposable),draft_still_unpublished=True)
        summary=os.environ.get('GITHUB_STEP_SUMMARY')
        if summary:
            with open(summary,'a') as output:
                output.write('## RPiOS upload recovery complete\n\nAll 21 fixed release assets match their pinned sizes and SHA-256 digests.\n\nThe four whole files were assembled and verified before upload. Only the approved empty failures and verified temporary transport family were removed. The release remains an unpublished draft. No body, tag, repository reference or other release was changed.\n')

if __name__=='__main__':
    try:main()
    except SafeError as error:
        print('Recovery stopped safely: '+str(error),file=sys.stderr);raise SystemExit(1)
    except Exception as error:
        print('Recovery stopped safely ('+type(error).__name__+').',file=sys.stderr);raise SystemExit(1)
