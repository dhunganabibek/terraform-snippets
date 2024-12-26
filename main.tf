resource "local_file" "test" {
  content  = "Hello, World!"
  filename = "${path.module}/test1.txt"
}