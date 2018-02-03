# Use case
You have a group of repos in Gitlab and want to clone all of them, quickly.

# Examples

- $1 should be group/namespace where source repos live.
- $2 should be the destination folder where the repos should be cloned to.

```
./sync-projects.sh namespacex /repos/repos_for_namespacex
./sync-projects.sh namespacey /repos/repos_for_namespacey
./sync-projects.sh namespacez /repos/repos_for_namespacez
```
