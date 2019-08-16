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
module "fw-rules" {
  source = "../modules/gcp-firewall-rule"

  network = "network-name"
  project = "project-1234"

  rules = {
   "default-egress-deny-all" = {
      deny = {
        "icmp" = []
        "tcp"  = []
        "udp"  = []
      }
      description        = "DEFAULT|EGRESS - DENY all outbound traffic to anywhere"
      direction          = "EGRESS"
      priority           = 65500
      destination_ranges = [ "0.0.0.0/0", ]
    }

    "default-ingress-deny-from-cidr-gcp" = {
      deny = {
        "icmp" = []
        "tcp"  = []
        "udp"  = []
      }
      description   = "DEFAULT|INGRESS - DENY all incoming traffic from private GCP Subnets"
      direction     = "INGRESS"
      priority      = 65490
      source_ranges = [ "10.200.0.0/15",
                        "10.140.0.0/16", ]
    }

    "default-ingress-allow-from-cidr-blizz" = {
      allow = {
        "icmp"      = []
        "tcp"       = [ "22", "3389", ] # SSH, Remote Desktop
      }
      description   = "DEFAULT|INGRESS - ALLOW ICMP, ssh and remote desktop incoming traffic from on-prem subnets"
      direction     = "INGRESS"
      priority      = 65500
      source_ranges = [ "10.0.0.0/8",
                        "192.168.0.0/16", ]
    }

    "ingress-allow-web-tag-from-cidr-private" = {
      allow = {
        "tcp"       = [ "80", "443" ]
      }
      direction     = "INGRESS"
      priority      = 10000
      source_ranges = [ "10.0.0.0/8" ]
      target_tags   = [ "web_server" ]
    }

    "ingress-allow-ssh-tag-from-tag" = {
      allow = {
        "tcp"     = [ "22" ]
      }
      direction   = "INGRESS"
      priority    = 10000
      source_tags = [ "ssh_client" ]
      target_tags = [ "ssh_server" ]
    }

    "ingress-allow-dns-tag-from-cidr-any" = {
      allow = {
        "tcp"       = [ "53" ]
        "udp"       = [ "53" ]
      }
      direction     = "INGRESS"
      priority      = 10000
      source_ranges = [ "0.0.0.0/0" ]
      target_tags   = [ "dns_server" ]
    }

    "ingress-allow-web-tag-from-team1-sas" = {
      allow = {
        "tcp"                 = [ "80" ]
      }
      destination_tags        = [ "dns_server" ]
      direction               = "INGRESS"
      priority                = 10000
      source_service_accounts = [ "service-account-1@example-project-12345.iam.gserviceaccount.com",
                                  "service-account-2@example-project-12345.iam.gserviceaccount.com" ]
    }
  }
}
```

## Map arguments reference

- https://www.terraform.io/docs/providers/google/r/compute_firewall.html

