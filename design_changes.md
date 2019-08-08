# DESIGN CHANGES

## Navigation

Top-level entries in this hierarchy represent the 'main navigation'. Main nav
is available on every page, e.g. menu on top of page.

The 2nd level entries in this hierarchy represent sections. Each section can
have its own section navigation that is only displayed when you are in that
section.

```yaml
- label: "Software"
  children:
    - label: "Hyrax 2.1"
      url: "/hyrax/2.1"
      children:
        - label: "Users"
        - label: "Developers"
          children:
            - label: "Getting Started"
        - label: "DevOps"
    - label: "Hyrax 2.0"
      url: "hyrax/2.0/"
      children:
        - label: "Users"
        - label: "Developers"
          children:
            - label: "Getting Started"
        - label: "DevOps"
    - label: "Hyrax 1.0"
      url: 'hyrax/1.0/'
      children:
        - label: "Users"
        - label: "Developers"
          children:
            - label: "Getting Started"
        - label: "DevOps"

- label: "Community"
  children:
    - label: "Get Help"
    - label: "Contributing"
    - label: "Github"
    - label: "Release Process"
    - label: "Communication"

- label: "About"
  children:
    - label: "What is Samvera"


- label: "Blog"
  children:
    - label: "Submit a request "
      url: "blog/request-documentation"
    - label: "Contribute documentation"
      url: "blog/contribute-documentation"
```


## Page Types

* **software_info**
  * Brief description of product.
  * Applicable links to:
    * Github
    * Rubygems

### Done when...

1. Main nav includes links to all product versions.

## Software Documentation Pages

Current navigation/organization doesn't really have the concept of a "section"
where you are looking at technical docs for a specific version of a given
software product.

### Done when...

1. Each tech doc page clearly shows which product+version it applies to.
1. Each tech doc page has section navigation specific to the product+version.
1. Main navigation includes links to all products+versions.
1. URLs for tech docs should follow something like /[product]/[version]/[page_title].html

## Add a Blog

We want to provide a uniform place for community members to share their
expertise, techniques, experiences, and opinions, which may be of value to the
rest of the community, but may not necessarily have a clear spot in the general
documentation.

### Done when...

1. `/blog` shows to chronological list of blog posts.
1. First blog posts:
   1. How to request new documentation (submit ticket in Github).
   1. How to contribute documentation (clone, add/edit, publish).

## Homepage

### Done when...

1. Don't use "tag" system for top-level categories. We don't want to link to a
   page of links. Link to content instead.
1. Drop the "Knowledge Base Categories" heading, shouldn't be necessary.
1. Include well labeled links to other primary resources:
   * [Samvera](https://samvera.org) Official Site
   * [Samvera](https://github.com/samvera) on Github
   * [Samvera](https://wiki.duraspace.org/display/samvera/) on Duraspace
1. Remove button "Contribute New Documentation". It just links to
   github.com/samvera/samvera.github.io without any further explanation.
