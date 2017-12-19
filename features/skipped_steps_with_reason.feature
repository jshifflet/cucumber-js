Feature: Skipped steps with reason

  Using this feature, a scenario can be imperatively 'skipped' with giving a reason

  There are three methods of skipping. Each with support for adding a reason.

  One for synchronous steps, one for an asynchronous callback, and one for an asynchronous promise.

  Background:
    Given a file named "features/skipped_with_reason.feature" with:
      """
      Feature: a feature
        Scenario: a scenario
          Given a skipped step with reason
      """

  Scenario: Synchronous skipped step with reason
    Given a file named "features/step_definitions/skipped_steps_with_reason.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a skipped step with reason$/, function() {
          return {status: "skipped", reason: "skipped reason"}
        })
      })
      """
    When I run cucumber.js
    Then it passes
    And the step "a skipped step with reason" has status "skipped"
    And the step "a skipped step with reason" has reason "skipped reason"

  Scenario: Callback skipped step with reason
    Given a file named "features/step_definitions/skipped_steps_with_reason.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a skipped step with reason$/, function(callback) {
          callback(null, {status: 'skipped', reason: 'skipped reason'})
        })
      })
      """
    When I run cucumber.js
    Then it passes
    And the step "a skipped step with reason" has status "skipped"
    And the step "a skipped step with reason" has reason "skipped reason"

  Scenario: Promise skipped step with reason
    Given a file named "features/step_definitions/skipped_steps_with_reason.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a skipped step with reason$/, function(){
          return {
            then: function(onResolve, onReject) {
              setTimeout(function() {
                onResolve({status: 'skipped', reason: 'skipped reason'})
              })
            }
          }
        })
      })
      """
    When I run cucumber.js
  #  Then it passes
  And the step "a skipped step with reason" has status "skipped"
  And the step "a skipped step with reason" has reason "skipped reason"

  Scenario: Hook skipped scenario steps
    Given a file named "features/support/hooks.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({After, Before}) => {
        Before(function() {return {status: 'skipped', reason: 'skipped in hook'}})
      })
      """
    And a file named "features/step_definitions/skipped_steps_with_reason.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a skipped step with reason$/, function() {
          var a = 1;
        })
      })
      """
    When I run cucumber.js
    Then it passes
    And the "Before" hook has status "skipped"
    And the "Before" hook has reason "skipped in hook"
