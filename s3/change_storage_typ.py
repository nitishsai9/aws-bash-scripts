import boto3

buckyName=input('bucket Name\n')
find_type=input('source type\n')
change_type=input('destination type\n')

s3 = boto3.client('s3')
resp=s3.list_objects_v2(Bucket=buckyName)


for i in resp['Contents']:
    # print(i['Key'],i['StorageClass'])
    if i['StorageClass']==find_type:
        s3.copy({'Bucket': buckyName,'Key':i['Key']}, buckyName, i['Key'], ExtraArgs = {'StorageClass': change_type,'MetadataDirective': 'COPY'})


    
