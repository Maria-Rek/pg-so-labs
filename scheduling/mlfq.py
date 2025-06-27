from collections import deque
from job import Job

def schedule(jobs):
    time = 0
    completed_jobs = []
    remaining_jobs = sorted(jobs, key=lambda x: x.arrival_time)

    q0 = deque()
    q1 = deque()
    q2 = deque()

    quantum_q0 = 2
    quantum_q1 = 4

    for job in jobs:
        job.remaining_time = job.burst_time
        job.start_time = None
        job.response_time = None
        job.completion_time = None
        job.turnaround_time = None
        job.waiting_time = None

    current_job = None
    current_quantum = 0
    current_queue = None

    while remaining_jobs or q0 or q1 or q2 or current_job:
        while remaining_jobs and remaining_jobs[0].arrival_time <= time:
            q0.append(remaining_jobs.pop(0))

        if not current_job:
            if q0:
                current_job = q0.popleft()
                current_quantum = quantum_q0
                current_queue = 0
            elif q1:
                current_job = q1.popleft()
                current_quantum = quantum_q1
                current_queue = 1
            elif q2:
                current_job = q2.popleft()
                current_quantum = current_job.remaining_time
                current_queue = 2

            if current_job and current_job.start_time is None:
                current_job.start_time = time
                current_job.response_time = time - current_job.arrival_time

        if current_job:
            current_job.remaining_time -= 1
            current_quantum -= 1

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
                current_queue = None
            elif current_quantum == 0:
                if current_queue == 0:
                    q1.append(current_job)
                elif current_queue == 1:
                    q2.append(current_job)
                else:
                    q2.append(current_job)
                current_job = None
                current_queue = None

        time += 1

    return completed_jobs
