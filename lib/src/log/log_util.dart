import 'default_logger.dart';
import 'logger.dart';

Logger logger = DefaultLogger();

void setLogger(Logger l) {
  logger = l;
}

Logger getLogger() {
  return logger;
}
