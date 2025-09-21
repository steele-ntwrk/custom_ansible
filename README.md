# Custom Ansible + NetBox Image

A Docker image for **network automation** with Ansible, NetBox, and common collections/tools pre-installed.  
It includes a project skeleton and a helper script to bootstrap new projects quickly.

---

## Features
- Based on Alpine with `ansible-core`
- Pre-installed:
  - [`pynetbox`](https://github.com/netbox-community/pynetbox)
  - `netbox.netbox` collection (dynamic inventory plugin, modules)
  - `community.network`, `community.general`, plus major vendor collections (Cisco, Arista, Juniper, Fortinet, etc.)
- Utilities: `sshpass`, `git`, `jq`, `curl`, `vim`, `rsync`, etc.
- Skeleton (`skel/`) for new projects
- `new_project.sh` script → bootstraps `/work/<project>` with the skeleton

---

## Usage

### Build
```bash
docker build -t custom_ansible_netbox:latest .
```

### Copy
```bash
docker pull ghcr.io/steele-ntwrk/custom_ansible:latest
```

### Confiugre docker-compose.yml
Mount points in docker-compose.yml:

./work → /work (project workspace)

./ssh → /root/.ssh (SSH keys, read-only)

./ansible_cache → /var/cache/ansibl


### Run
```bash
docker-compose up -d
```

### Jump in to the container
```bash
bash jumpin.sh
```

### Create a new ansible project
```bash
cd /work
new_project.sh mylab
ls mylab/
```

### Dynamic Inventory
Create a inventory file to dynamically get inventory from your netbox instance
```bash
plugin: netbox.netbox.nb_inventory
api_endpoint: "{{ NETBOX_URL }}"        # e.g. http://10.10.10.10:8080 
token: "{{ NETBOX_TOKEN }}"             # NetBox API token
validate_certs: false                   # set true if using HTTPS with trusted CA

group_by: [sites, platforms]
```
