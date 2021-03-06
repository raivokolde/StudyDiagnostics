StudyDiagnostics
================

[![Build Status](https://travis-ci.org/OHDSI/StudyDiagnostics.svg?branch=master)](https://travis-ci.org/OHDSI/StudyDiagnostics)
[![codecov.io](https://codecov.io/github/OHDSI/StudyDiagnostics/coverage.svg?branch=master)](https://codecov.io/github/OHDSI/StudyDiagnostics?branch=master)

Introduction
============
This is an R package for performing various study diagnostics, many of which are not specific to any particular study design.

Features
========
- Show cohort inclusion rule attrition. 
- List all source codes used when running a cohort definition on a specific database.
- Find orphan codes, (source) codes that should be, but are not included in a particular concept set.
- Compute cohort incidence across calendar years, age, and gender.
- Break down index events into the specific concepts that triggered them.
- Compute overlap between two cohorts.
- Characterize cohorts, and compare these characterizations.

Examples
========
TODO

Technology
==========
The StudyDiagnostics package is an R package.

System Requirements
===================
Running the package requires R with the package rJava installed. Also requires Java 1.7 or higher.

Installation
=============
## R package

To install the latest development version, install from GitHub:

```r
install.packages("devtools")
devtools::install_github("ohdsi/ROhdsiWebApi")
devtools::install_github("ohdsi/FeatureExtraction")
devtools::install_github("ohdsi/StudyDiagnostics")
```

User Documentation
==================
* Package manual: [StudyDiagnostics manual](https://ohdsi.github.io/StudyDiagnostics/reference/index.html) 

Support
=======
* Developer questions/comments/feedback: <a href="http://forums.ohdsi.org/c/developers">OHDSI Forum</a>
* We use the <a href="https://github.com/OHDSI/StudyDiagnostics/issues">GitHub issue tracker</a> for all bugs/issues/enhancements

License
=======
StudyDiagnostics is licensed under Apache License 2.0

Development
===========
StudyDiagnostics is being developed in R Studio.

### Development status

Under development. Do not use.
