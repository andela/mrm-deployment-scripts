path "mrm/keys" {
  capabilities = ["read"]
}

path "mrm/postgresdb" {
  capabilities = ["read"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}
