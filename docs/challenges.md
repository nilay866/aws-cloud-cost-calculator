
## GitHub push blocked (large files + push protection)
**Problem:**
My first push failed because I accidentally committed generated files like:
- Terraform provider folder (.terraform)
- zipped build files
- AWS CLI installer files

GitHub also blocked one commit because an example file inside AWS CLI contained a secret-like string.

**Fix:**
- Added .gitignore for terraform generated files and zip files
- Removed large files from git history using git filter-repo
- Force pushed cleaned history

**Lesson:**
Always ignore generated files:
- terraform/.terraform/
- terraform.tfstate
- *.zip
