# Contributing

Keep contributions focused on one team module where practical. Discuss changes
to exported function arguments with the teams that consume them. Include a small
reproducible example and meaningful tests for new behavior.

Every pull request requires approval from at least three reviewers before merge.
A repository administrator must configure the hosting platform's branch protection
or ruleset to require three approving reviews on the default branch. This file and
the PR template document the policy; they do not enforce it.

Before requesting review, run R CMD build and R CMD check --no-manual, and explain
any warnings or limitations. Never commit private or sensitive application data.
