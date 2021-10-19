terraform {
  required_providers {

    test = {
      source = "terraform.io/builtin/test"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.86.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.86.0"
    }
  }
}

module "main" {
  # source is always ../.. for test suite configurations,
  # because they are placed two subdirectories deep under
  # the main module directory.
  source = "../.."

  # This test suite is aiming to test the "defaults" for
  # this module, so it doesn't set any input variables
  # and just lets their default values be selected instead.
}

# # As with all Terraform modules, we can use local values
# # to do any necessary post-processing of the results from
# # the module in preparation for writing test assertions.
# locals {
#   # This expression also serves as an implicit assertion
#   # that the base URL uses URL syntax; the test suite
#   # will fail if this function fails.
#   api_url_parts = regex(
#     "^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?",
#     module.main.api_url,
#   )
# }


