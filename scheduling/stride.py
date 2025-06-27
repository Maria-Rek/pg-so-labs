from job import Job

def schedule(jobs):
    STRIDE_CONSTANT = 10_000
    time = 0
    completed_jobs = []
    available_jobs = []
    remaining_jobs = sorted(jobs, key=lambda x: x.arrival_time)

    for job in jobs:
        job.stride = STRIDE_CONSTANT // max(1, job.priority)
        job.pass_value = 0
        job.start_time = None
        job.response_time = None
        job.completion_time = None
        job.turnaround_time = None
        job.waiting_time = None

    while remaining_jobs or available_jobs:
        while remaining_jobs and remaining_jobs[0].arrival_time <= time:
            job = remaining_jobs.pop(0)
            available_jobs.append(job)

        if not available_jobs:
            time += 1
            continue

        available_jobs.sort(key=lambda x: x.pass_value)
        current_job = available_jobs.pop(0)

        if current_job.start_time is None:
            current_job.start_time = time
            current_job.response_time = time - current_job.arrival_time

        time += current_job.burst_time
        current_job.completion_time = time
        current_job.turnaround_time = current_job.completion_time - current_job.arrival_time
        current_job.waiting_time = current_job.turnaround_time - current_job.burst_time
        current_job.pass_value += current_job.stride

        completed_jobs.append({
            "job_name": current_job.name,
            "waiting_time": current_job.waiting_time,
            "turnaround_time": current_job.turnaround_time,
            "response_time": current_job.response_time
        })

    return completed_jobs
