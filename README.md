# GoalTracker

A blockchain-based personal goal achievement tracking system built on the Stacks blockchain.

## Overview

GoalTracker allows users to set targets, track their contributions toward those targets, and verify their progress over time. The system provides a transparent and immutable record of achievement that can be used for personal accountability or verified by third parties.

## Features

- **Contribution Tracking**: Record contributions toward your goals with blockchain verification
- **Target Setting**: Set measurable targets to work toward
- **Progress Monitoring**: Check your current status at any time
- **Event Notifications**: Emit events for key milestones like setting targets and reaching goals
- **Immutable Records**: All progress is stored permanently on the blockchain

## How It Works

1. **Create an Objective**: Your first contribution automatically creates your objective record
2. **Set a Target**: Define what you aim to achieve using the `set-target` function
3. **Track Contributions**: Record your progress by making contributions
4. **Monitor Status**: Check your current status to see how close you are to reaching your goal

## Smart Contract Functions

### Public Functions

- `contribute(amount)`: Record a contribution toward your goal
- `set-target(target)`: Set or update your target amount
- `check-status()`: Get a report on your current progress

### Events

The contract emits the following events:

- `contribution`: When a user records a contribution
- `target-set`: When a user sets or updates their target
- `target-reached`: When a user reaches their target

## Usage Example

```clarity
;; Record a contribution of 100 units
(contract-call? .achiever contribute u100)

;; Set a target of 1000 units
(contract-call? .achiever set-target u1000)

;; Check your current status
(contract-call? .achiever check-status)
```

## Development

### Prerequisites

- Clarity language knowledge
- Stacks blockchain development environment
- Clarinet for local testing

### Testing

Run tests with Clarinet:

```bash
clarinet test
```

## Future Enhancements

- Multiple objectives per user
- Social features for group accountability
- Achievement badges and NFT rewards
- Time-based objectives with deadlines
