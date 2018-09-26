#---------------------------------------------#
# Random id #
#---------------------------------------------#
resource "random_id" "prod_bucket_id" {
  byte_length = 2
}

#---------------------------------------------#
# S3 bucket #
#---------------------------------------------#
resource "aws_s3_bucket" "otto_bucket" {
  bucket = "otto-bucket-${random_id.prod_bucket_id.dec}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "server-files" {
  bucket = "${aws_s3_bucket.otto_bucket.bucket}"
  key    = "server-files.tar.gz"
  source = "./server_files.tar.gz"
}

resource "aws_s3_bucket_object" "boot-file" {
  bucket = "${aws_s3_bucket.otto_bucket.bucket}"
  key    = "bootstrap.sh"
  source = "./webserver_scripts/bootstrap.sh"
}
