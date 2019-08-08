# terraform-gcp-firewall-rule

Terraform module :: GCP :: for network firewall rule(s) creation and management

## Compatibility

This module is meant for use with Terraform >=0.12.6. If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-12.html) and need a Terraform 0.11.x-compatible
version of this module, you are out of luck!

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| network | Network \(name\) to apply the rules to. | string | n/a | yes |
| project | The project \(ID\) in which the network lives. | string | n/a | yes |
| rules | Map of maps defining firewall rules | map(map) | n/a | yes |

## Usage

```hcl
module "iam_binding" {
  source = "../modules/gcp-firewall-rule"

  network = "network-name"
  project = "project-1234"

  rules = {
    "ingress-allow-web-tag-from-cidr-private" = {
        allow = {
          "tcp"          = [ "80", "443" ]
        }
        destination_tags = [ "web_server" ]
        direction        = "INGRESS"
        source_ranges    = [ "10.0.0.0/8" ]
    }

    "ingress-deny-imcp-from-cidr-any" = {
        deny = {
          "icmp"      = []
        }
        direction     = "INGRESS"
        source_ranges = [ "0.0.0.0/0" ]
    }

    "ingress-allow-ssh-tag-from-tag" = {
        allow = {
          "tcp"          = [ "22" ]
        }
        destination_tags = [ "ssh_server" ]
        direction        = "INGRESS"
        source_tags      = [ "ssh_client" ]
    }

    "ingress-allow-dns-tag-from-cidr-any" = {
        allow = {
          "tcp"          = [ "53" ]
          "udp"          = [ "53" ]
        }
        destination_tags = [ "dns_server" ]
        direction        = "INGRESS"
        source_ranges    = [ "0.0.0.0/0" ]
    }

    "ingress-allow-web-tag-from-team1-sas" = {
      allow = {
        "tcp"                 = [ "80" ]
      }
      destination_tags        = [ "dns_server" ]
      direction               = "INGRESS"
      source_service_accounts = [ "terraform@team1-project1-12345.iam.gserviceaccount.com", "jenkins@team1-project1-12345.iam.gserviceaccount.com" ]
    }
  }
}
```

## References

- https://www.terraform.io/docs/providers/google/r/compute_firewall.html

