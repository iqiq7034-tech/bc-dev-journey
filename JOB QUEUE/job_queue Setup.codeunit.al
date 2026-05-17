codeunit 50106 "Job Queue Setup"
{
    procedure CreateNightlySyncedEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        NightlyTime: Time;
    begin
        JobQueueEntry.SetRange(
            "Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);

        JobQueueEntry.SetRange(
            "Object ID to Run", 50105);

        if not JobQueueEntry.IsEmpty then begin
            Message('Job queue entry for nightly synced already exists.');
            exit;
        end;
        NightlyTime := 020000T; // 2:00 AM


        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := 50105; // Nightly API Sync codeunit
        JobQueueEntry.Description := 'Nightly API Sync __ Exchange Rates + uSers';


        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        JobQueueEntry."Starting Time" := NightlyTime;
        JobQueueEntry."No. of Minutes between Runs" := 0;


        JobQueueEntry.Status := JobQueueEntry.Status::Ready;

        JobQueueEntry.Insert(true);


        Message('Job Queue entry created!\n' + 'Codeunit 50105 will run every night at 02:00AM.\n' + 'Open Job Queue Entries to verify.');

    end;


    procedure CreateHourlySyncEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" :=
            JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := 50215;
        JobQueueEntry.Description :=
            'Hourly Exchange Rate Sync';

        // Run every 60 minutes
        JobQueueEntry."No. of Minutes between Runs" := 60;

        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;

        JobQueueEntry.Status :=
            JobQueueEntry.Status::Ready;

        JobQueueEntry.Insert(true);

        Message('Hourly sync entry created!\n' +
                'Will run every 60 minutes on weekdays.');
    end;

}