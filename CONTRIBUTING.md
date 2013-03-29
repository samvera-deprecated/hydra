# How to Contribute

We want your help to make Project Hydra great.
There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

## Getting Started

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Submit a [Github issue](https://github.com/projecthydra/hydra/issues) by:
  * Clearly describing the issue
    * Provide a descriptive summary
    * Explain the expected behavior
    * Explain the actual behavior
    * Provide steps to reproduce the actual behavior
* Fork the repository on GitHub

## Making Changes

* Create a topic branch from where you want to base your work.
  * This is usually the master branch.
  * To quickly create a topic branch based on master; `git branch fix/master/my_contribution master`
  * Then checkout the new branch with `git checkout fix/master/my_contribution`.
  * Please avoid working directly on the `master` branch.
  * You may find the [hub suite of commands](https://github.com/defunkt/hub) helpful
* Make commits of logical units.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Make sure your commit messages are in the
  [proper format](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

```
    Present tense short summary (50 characters or less)

    More detailed description, if necessary. It should be wrapped to 72
    characters. Try to be as descriptive as you can, even if you think that
    the commit content is obvious, it may not be obvious to others. You
    should add such description also if it's already present in bug tracker,
    it should not be necessary to visit a webpage to check the history.

    Description can have multiple paragraphs and you can use code examples
    inside, just indent it with 4 spaces:

        class PostsController
          def index
            respond_with Post.limit(10)
          end
        end

    You can also add bullet points:

    - you can use dashes or asterisks

    - also, try to indent next line of a point for readability, if it's too
      long to fit in 72 characters
```

* Make sure you have added the necessary tests for your changes.
* Run _all_ the tests to assure nothing else was accidentally broken.

## Hydra Project Intellectual Property Licensing and Ownership

All code contributors must have an Individual Contributor License Agreement (iCLA) on file with the Hydra Project Steering Group.
If the contributor works for an institution, the institution must have a Corporate Contributor License Agreement (cCLA) on file.

https://wiki.duraspace.org/display/hydra/Hydra+Project+Intellectual+Property+Licensing+and+Ownership

## Submitting Changes

* Push your changes to a topic branch in your fork of the repository.
* Submit a pull request to the project https://github.com/hydra/hydra
* Update your Github issue – if you use the hub command, this can be automated – by associating the issue with the pull request.

# Additional Resources

* [General GitHub documentation](http://help.github.com/)
* [GitHub pull request documentation](http://help.github.com/send-pull-requests/)