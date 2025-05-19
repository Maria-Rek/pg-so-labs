from collections import deque
from job import Job

def schedule(jobs):
    time = 0
    completed_jobs = []
    job_queue = []
    jobs = sorted(jobs, key=lambda x: x.arrival_time)
    remaining_jobs = jobs[:]
    current_job = None

    while remaining_jobs or job_queue or current_job:
        while remaining_jobs and remaining_jobs[0].arrival_time <= time:
            job = remaining_jobs.pop(0)
            job.remaining_time = job.burst_time
            job_queue.append(job)

        if job_queue or current_job:
            if current_job:
                job_queue.append(current_job)
                current_job = None

            job_queue.sort(key=lambda x: x.remaining_time)
            current_job = job_queue.pop(0)

            if current_job.start_time is None:
                current_job.start_time = time
                current_job.response_time = time - current_job.arrival_time

            current_job.remaining_time -= 1

            if current_job.remaining_time == 0:
                current_job.completion_time = time + 1
                current_job.turnaround_time = current_job.completion_time - current_job.arrival_time
                current_job.waiting_time = current_job.turnaround_time - current_job.burst_time
                completed_jobs.append({
                    "job_name": current_job.name,
                    "waiting_time": current_job.waiting_time,
                    "turnaround_time": current_job.turnaround_time,
                    "response_time": current_job.response_time
                })
                current_job = None
        time += 1

    return completed_jobs
