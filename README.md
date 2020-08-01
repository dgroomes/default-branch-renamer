# default-branch-renamer NOT YET IMPLEMENTED

A Bash script to rename the default branch for a Github repository.

---

Executes the following:

* Asserts that the "master" branch is currently checked out
* Asserts that there are no changes (staged or unstaged)
* "git pull"
* Checks out a new branch called "main"
* Pushes "main"
* Use the GitHub API to make "main" the "default branch"