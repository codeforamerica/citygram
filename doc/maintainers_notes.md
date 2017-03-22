## Jobs queue

There exists a citygram-jobs app in Heroku to monitor job health.  Code for America and Jim have access.

## Database

This function pair can trim historical events.  First run 2/16/17
```
CREATE FUNCTION delete_when_ready() RETURNS INTEGER LANGUAGE plpgsql AS $$
DECLARE batched_count INTEGER = 1;
BEGIN
    WITH old_events AS (
        SELECT id
        FROM events
        WHERE created_at < CURRENT_DATE - INTERVAL '1' YEAR
        LIMIT 1000
        FOR UPDATE NOWAIT
    ),
    deleted_events AS (
        DELETE FROM events
        USING old_events
        WHERE old_events.id = events.id
        RETURNING events.id
    ) SELECT COUNT(1) INTO batched_count FROM deleted_events;
    RETURN batched_count;
END$$;

DO LANGUAGE plpgsql $$
DECLARE counter INTEGER = 1;
BEGIN
    WHILE counter > 0 LOOP
        SELECT INTO counter delete_when_ready();
    END LOOP;
END$$;
```