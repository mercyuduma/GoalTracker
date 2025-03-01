;; File: achiever.clar
;; A personal goal achievement tracker for tracking contributions and progress.
(define-map objectives
  { participant: principal }
  { contributions: uint, target: uint, completion: uint })

;; Event definitions
(define-constant CONTRIBUTION_EVENT "contribution")
(define-constant TARGET_SET_EVENT "target-set")
(define-constant TARGET_REACHED_EVENT "target-reached")

(define-map event-records
  { type: (string-ascii 20), participant: principal }
  { amount: uint })

;; Private helper functions to emit custom events. The print function simulates event emission.
(define-private (emit-contribution (participant principal) (amount uint))
    (begin
        (map-insert event-records { type: CONTRIBUTION_EVENT, participant: participant } { amount: amount })
        (print { event: CONTRIBUTION_EVENT, participant: participant, amount: amount })
        (ok true)))

;; Allow users to record contributions toward their goal.
(define-public (contribute (amount uint))
    (let ((current-objective (map-get? objectives { participant: tx-sender })))
        (if (is-some current-objective)
            ;; Update existing contribution record
            (let ((objective-data (unwrap! current-objective (err "Missing record")))
                  (current-contributions (get contributions objective-data))
                  (current-target (get target objective-data))
                  (current-completion (get completion objective-data))
                  (new-contributions (+ current-contributions amount)))
                (begin
                    (map-set objectives { participant: tx-sender }
                        { contributions: new-contributions, target: current-target, completion: current-completion })
                    (asserts! (is-ok (emit-contribution tx-sender amount)) (err "Failed to emit contribution event"))
                    (ok amount)))
            (begin
                (print { type: "objective-created", participant: tx-sender })
                (map-set objectives { participant: tx-sender }
                    { contributions: amount, target: u0, completion: u0 })
                (asserts! (is-ok (emit-contribution tx-sender amount)) (err "Failed to emit contribution event"))
                (ok amount)))))

;; Set a target for participant goal.
(define-public (set-target (target uint))
    (let ((current-objective (map-get? objectives { participant: tx-sender })))
        (if (is-some current-objective)
            (let ((objective-data (unwrap! current-objective (err "Objective data not found")))
                  (current-contributions (get contributions objective-data))
                  (current-completion (get completion objective-data)))
                (begin
                    (asserts! (> target u0) (err "Target must be greater than zero"))
                    (map-set objectives { participant: tx-sender }
                        { contributions: current-contributions, target: target, completion: current-completion })
                    (print { event: TARGET_SET_EVENT, participant: tx-sender, target: target })
                    (ok target)))
            (err "Objective record not found"))))

;; Check if the participant has reached their target.
(define-public (check-status)
    (let ((current-objective (map-get? objectives { participant: tx-sender })))
        (if (is-some current-objective)
            (let ((objective-data (unwrap! current-objective (err "Objective data not found")))
                  (contributions (get contributions objective-data))
                  (target (get target objective-data)))
                (if (>= contributions target)
                    (begin
                        (print { event: TARGET_REACHED_EVENT, participant: tx-sender, target: target })
                        (ok { status: "Completed", target: target, contributions: contributions }))
                    (ok { status: "In Progress", target: target, contributions: contributions })))
            (err "Objective record not found"))))