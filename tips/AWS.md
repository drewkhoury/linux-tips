# linux-tips :: aws

## Find the owner of and AWS Access Key
http://stackoverflow.com/questions/24028610/find-the-owner-of-and-aws-access-key

If you don't have access to your account's primary access key, but you do have an access key with sufficient access to IAM, you can enumerate all the users in the account and then list the access keys for each of them. For example:

```
for user in $(aws iam list-users --output text | awk '{print $NF}'); do
    aws iam list-access-keys --user $user --output text
done
```