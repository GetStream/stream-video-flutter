#ifndef PACKAGES_FLUTTER_WEBRTC_LINUX_TASK_RUNNER_LINUX_H_
#define PACKAGES_FLUTTER_WEBRTC_LINUX_TASK_RUNNER_LINUX_H_

#include <memory>
#include <mutex>
#include <queue>
#include "task_runner.h"

namespace stream_webrtc_flutter_plugin {

class TaskRunnerLinux : public TaskRunner {
 public:
  TaskRunnerLinux() = default;
  ~TaskRunnerLinux() override = default;

  // TaskRunner implementation.
  void EnqueueTask(TaskClosure task) override;

 private:
  std::mutex tasks_mutex_;
  std::queue<TaskClosure> tasks_;
};

}  // namespace stream_webrtc_flutter_plugin

#endif  // PACKAGES_FLUTTER_WEBRTC_LINUX_TASK_RUNNER_LINUX_H_