path "mrm/keys" {
  capabilities = ["read"]
}

path "mrm/postgresdb" {
  capabilities = ["read"]
}

path "mrm/bugsnag" {
  capabilities = ["read"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}
