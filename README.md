# Terraform snippets



Running tf file.

```
1. terraform init
2. terraform plan 
3. terraform apply
4. terraform destroy
```

Syntax
```
<block> <parameters> {
    key1 = value1
    key2 = value2
} 
```

### create variable in tf
```
variable "vaiable_name" {
  description = "description"
  type = string, map , list , number, any, 
  default = "value" 
}
```

## adding output variable
```
output "output-variable" {
  value = "hello"
}
```
