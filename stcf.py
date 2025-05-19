# algorithms/stcf.py

from scheduler import Scheduler

class STCFScheduler(Scheduler):
    def __init__(self):
        self.kolejka = []
        self.biezacy = None

    def add_process(self, process):
        self.kolejka.append(process)

    def get_next_process(self, current_process, current_time):
        if current_process and current_process.remaining_time > 0:
            self.kolejka.append(current_process)

        if not self.kolejka:
            return None

        self.kolejka.sort(key=lambda p: p.remaining_time)
        return self.kolejka.pop(0)
