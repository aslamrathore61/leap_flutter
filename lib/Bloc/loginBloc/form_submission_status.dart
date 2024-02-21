import '../../models/CreateUpdateCardRequestResponse.dart';
import '../../models/LoginResponse.dart';

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final Object exception;

  SubmissionFailed(this.exception);
}

/*   Login Submittion  */
class SubmissionLoginSuccess extends FormSubmissionStatus {
  final LoginResponse loginResponse;

  const SubmissionLoginSuccess(this.loginResponse);
}


/*   Submit Business Card   */
class SubmissionBusinessCardSuccess extends FormSubmissionStatus {
  final CreateUpdateCardResponse createUpdateCardResponse;

  const SubmissionBusinessCardSuccess(this.createUpdateCardResponse);
}
