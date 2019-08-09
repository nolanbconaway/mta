
workflow "Build, Lint, Test" {
  on = "push"
  resolves = ["Pytest"]
}

action "Install" {
  uses = "nolanbconaway/python-actions@master"
  args = "pip install poetry && poetry install --extras cli && poetry shell && which python"
}

action "Black" {
  uses = "nolanbconaway/python-actions@master"
  args = "black underground test --check --verbose"
  needs = ["Install"]
}

action "Pydocstyle" {
  uses = "nolanbconaway/python-actions@master"
  args = "pydocstyle underground test --verbose"
  needs = ["Install"]
}

action "Pylint" {
  uses = "nolanbconaway/python-actions@master"
  args = "pylint underground test -d C0303,C0412,C0330,E1120,R0201,E0213,R0903"
  needs = ["Install"]
}

action "Pytest" {
  uses = "nolanbconaway/python-actions@master"
  args = "pytest . -v"
  needs = ["Black", "Pydocstyle", "Pylint"]
}