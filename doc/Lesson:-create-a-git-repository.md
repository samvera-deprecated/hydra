Note: This lesson is basically equivalent to the [Create A New Git Repo](http://curriculum.railsbridge.org/curriculum/create_a_new_git_repo) step in the RailsBridge Curriculum.

# Goals
* Create a local git repository that will track all changes to this application's code

# Explanation

In order to track the changes you make to your code, to share your changes with others, and to pull other people's changes into your code, you need some form of Version Control.  All of the Hydra projects use Git for version control and share their work on Github.

# Steps

Now, let's turn this directory into a git repository.  Type the following:

```bash
$> git init .
```

Then you should see something like this:

```
Initialized empty Git repository in /Users/justin/hydra-demo/.git/
```

Next, we'll add all the files rails created into the repository.  This way we can jump back to this state later if the need arises.

```bash
$> git add .
$> git commit -m "Initial rails application"
```

# Next Step
Go on to [[Lesson: Add the Hydra Dependencies]] or return to the [[Dive into Hydra]] page.