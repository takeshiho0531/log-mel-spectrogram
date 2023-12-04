// test stimuli
initial begin
    wait (reset == 1);
    wait (reset == 0);
    repeat(10) @(posedge clock);
    fork
        begin
            LoadInputData("input4.txt");
            GenerateInputWave;
            LoadInputData("input5.txt");
            GenerateInputWave;
        end
        begin
            wait (do_en ==1);
            repeat(N) @(posedge clock);
            SaveOutputData("output4.txt");
            @(negedge clock);
            wait (do_en == 1);
            repeat(N) @(posedge clock);
            SaveOutputData("output5.txt");
        end
    join

    repeat(10) @(posedge clock);
    $finish;
end

initial begin
    repeat(1000) #20;
    $display("[FAILED] Simulation timed out.");
    $finish;
end