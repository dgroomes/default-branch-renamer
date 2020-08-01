# default-branch-renamer

A Bash script to rename the default branch for a Github repository.

---

The `default-branch-renamer.sh` script renames the "master" branch in the git
repo in the current workin directory to "main". It also sets "main" as the
"default" branch in GitHub by using the GitHub API.

Executes the following:

* Asserts that the "master" branch is currently checked out
* Asserts that there are no changes (staged or unstaged)
* "git pull"
* Checks out a new branch called "main"
* Pushes "main"
* Use the GitHub API to make "main" the "default branch"

### Issues

* The regexes are not perfect