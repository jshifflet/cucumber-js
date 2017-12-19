Feature: Pending steps

  Background:
    Given a file named "features/pending_steps_with_reason.feature" with:
      """
      Feature: a feature
        Scenario: a scenario
          Given a pending step with reason
      """

  Scenario: Synchronous pending step
    Given a file named "features/step_definitions/failing_steps.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a pending step with reason$/, function() {
          return {status: 'pending', reason: 'pending reason'}
        })
      })
      """
    When I run cucumber.js
    Then it fails
    And the step "a pending step with reason" has status "pending"
    And the step "a pending step with reason" has reason "pending reason"

  Scenario: Callback pending step
    Given a file named "features/step_definitions/failing_steps.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a pending step with reason$/, function(callback) {
          callback(null, {status: 'pending', reason: 'pending reason'})
        })
      })
      """
    When I run cucumber.js
    Then it fails
    And the step "a pending step with reason" has status "pending"
    And the step "a pending step with reason" has reason "pending reason"


  Scenario: Promise pending step
    Given a file named "features/step_definitions/failing_steps.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a pending step with reason$/, function(){
          return {
            then: function(onResolve, onReject) {
              setTimeout(function() {
                onResolve({status: 'pending', reason: 'pending reason'})
              })
            }
          }
        })
      })
      """
    When I run cucumber.js
    Then it fails
    And the step "a pending step with reason" has status "pending"
    And the step "a pending step with reason" has reason "pending reason"

  Scenario: Hook pending scenario steps
    Given a file named "features/support/hooks.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({After, Before}) => {
        Before(function() {return {status: 'pending', reason: 'pending in hook'}})
      })
      """
    And a file named "features/step_definitions/pending_steps_with_reason.js" with:
      """
      import {defineSupportCode} from 'cucumber'

      defineSupportCode(({Given}) => {
        Given(/^a pending step with reason$/, function() {
          var a = 1;
        })
      })
      """
    When I run cucumber.js
    Then it fails
    And the "Before" hook has status "pending"
    And the "Before" hook has reason "pending in hook"
