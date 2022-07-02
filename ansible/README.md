# Server setup with Ansible

- Install Ansible
- Add VPS IP to `~/.ansiblehosts`:

```
[kapselistudio]
111.222.333.444	ansible_user=root
```

- Install dependencies
  - `ansible-galaxy install -r requirements.yml`
- Run the playbook
  - `ansible-playbook -i ~/.ansiblehosts --extra-vars "secret_key_base=<64 CHAR SECRET>" playbook.yml`

## Setting up the domain

- Add an A record `@` to the IP

## Deploying the app

- `git remote add dokku dokku@<IP ADDRESS>:kapselistudio`
- `git push dokku main:master`
- Run migrations on remote with `dokku run kapselistudio mix ecto.setup`

## Interacting with the DB

- Get access to PSQL CLI with
  - `docker exec -it <CONTAINER ID> psql -U postgres -d kapselistudio`

## Bootstrapping a podcast episode data

- Generate insert clauses from podcast RSS
  - `elixir scripts/parse_rss/parse_rss.exs feed.xml`
- Copy the resulting file to remote and in the Postgres Docker container
  - `scp inserts.sql root@<IP ADDRESS>:/root`
  - `docker cp inserts.sql <CONTAINER ID>:/tmp`
  - `docker exec -it <CONTAINER ID> psql -U postgres -d kapselistudio -f /tmp/inserts.sql`
