# Challenges I Faced

1) GitHub push failed due to large generated files
- terraform/.terraform providers and zip files got committed by mistake
Fix:
- Added .gitignore
- Removed large files from git history and pushed again

2) SNS subscription pending confirmation
Fix:
- Confirmed subscription from Gmail

3) iPad editing issues
Fix:
- Used EOF (heredoc) method to create files from terminal
