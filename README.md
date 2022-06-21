# devops-gitsync
For git repos synchronization

## Installation

Download this repo and make gitsync.sh executable:

```bash
cp gitsync.sh /usr/local/bin/gitsync
chmod +x /usr/local/bin/gitsync
```

## Usage

For usage required valid ssh-keys for GitHub & GitLab and also github-cli utilite(for list of repos in GitHub)

gh2gl.sh is script for mirroring repos for organization from GitHub to Gitlab. Names of groups & repos will be identical(GitHub --> GitLab)

gh2gl.conf is config file for the srcipt. There are indicated:

1. DIR - directory for creating local repos from GitHub for further mirroring
2. GITLAB - url of your gitlab instance

Config file is expected to /opt path(see script code)


## Example

```bash
chmod +x gh2gl.sh
./gh2gl.sh create/sync <ORGANIZATION>
