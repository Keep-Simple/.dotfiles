---
name: bdd-patterns
description: >
  Write and review test scenarios, acceptance criteria, and feature specs using
  strict Given-When-Then / Gherkin structure — feature files, scenario outlines,
  and step definitions where a cucumber-style runner exists; equivalent
  Given-When-Then test names/describe-blocks otherwise. Default to this
  structure for any new test or acceptance criterion, in every repo.
  Trigger: "write tests", "BDD", "gherkin", "given when then", "feature file",
  "acceptance criteria", "scenario outline", "cucumber", or /bdd-patterns.
---

# bdd-patterns

## Rule

Every test scenario and acceptance criterion is Given-When-Then. Not a suggestion — the default shape unless the user explicitly asks for something else.

- **Given**: preconditions/state.
- **When**: the single action or event under test.
- **Then**: the expected outcome.
- One behavior per scenario. "And also" is a second scenario, not an `And` step tacked onto this one.
- No cucumber/gherkin runner in the repo → don't add one. Fold the same three parts into the test framework's own naming (see below).

## Reference structure

```gherkin
Feature: Shopping Cart
  As a customer
  I want to manage items in my cart
  So that I can purchase products I'm interested in

  Background:
    Given I am logged in as a customer

  Scenario: Add item to empty cart
    Given my cart is empty
    When I add "Blue T-Shirt" to my cart
    Then my cart should contain 1 item

  Scenario Outline: Password validation
    Given I am on the registration page
    When I enter password "<password>"
    Then I should see "<message>"

    Examples:
      | password   | message              |
      | abc        | Password too short   |
      | abcdefgh1  | Password accepted    |
```

- `Background` for setup shared by every scenario in the feature — don't repeat it per-scenario.
- `Scenario Outline` + `Examples` for the same steps against different data — don't hand-duplicate near-identical scenarios.
- Step definitions bind one line of Gherkin to one thin function; push logic into helpers, not the step body:

```ruby
Given('a registered user with email {string}') do |email|
  @user = User.create!(email: email, password: 'password123')
end
```

## No gherkin runner? Map it anyway

| Layer | Given | When | Then |
|---|---|---|---|
| Jest/RSpec/etc. nested blocks | outer `describe`/`context` | inner `describe`/`context` | `it`/`test` |
| Go table-driven / flat test funcs | fold all three into the test name | | |

Example: `TestLogin_GivenValidCredentials_WhenSubmitted_ThenRedirectsToDashboard`, or `describe("given a registered user") > describe("when login submitted") > it("then redirects to dashboard")`.

## Reject

- Steps naming implementation details (CSS selectors, endpoint paths, DOM IDs) instead of behavior.
- Multiple behaviors crammed into one scenario.
- `Scenario Outline` used to avoid writing a plain `Scenario` for unrelated cases.
- Feature files left stale after behavior changes — they're code, update them in the same commit.
