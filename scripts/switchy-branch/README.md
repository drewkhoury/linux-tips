# Use case

You have a group of repos, some/most of which are on the master branch, and you want to quickly determine what the "latest semver'd branch" (e.g v6.0.0 is newer than v1.0.0).

# Examples

- $1 should be the destination folder where repos live.

```
./switch-branch.sh /path/to/base/folder
```

# Buyers Beware

This works well for repos with a predictable structure.

This script will ignore strage looking semver e.g `v1.0.0-development`.

If no winning/latest semver branch can be determined, nothing will be done.

If the repo is not on master, nothing will be done.
