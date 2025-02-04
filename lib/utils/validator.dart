import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

final mobileValidator = MultiValidator([
  RequiredValidator(errorText: kEnterMobileNumber),
  MinLengthValidator(10, errorText: kEnterValidMobileNumber),
]);
final mobileCodeValidator = MultiValidator([
  RequiredValidator(errorText: kEnterCountryCode),
]);
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'please_enter_password'.tr),
  MinLengthValidator(6, errorText: 'password_should_be_6_or_more_characters'.tr),
]);

/*final confPasswordValidator = MultiValidator([
  RequiredValidator(errorText: kEnterConfPassword),
  MinLengthValidator(6, errorText: kEnterValidPassword),
]);*/

final dateOfBirthValidator = MultiValidator([
  RequiredValidator(errorText: 'enter_dob'.tr),
  MinLengthValidator(9, errorText: 'enter_valid_dob'.tr),
]);

final userNameValidator = MultiValidator([
  RequiredValidator(errorText: kEnterUserName),
  MinLengthValidator(3, errorText: kEnterValidUserName),
]);
final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'please_enter_name'.tr),
  MinLengthValidator(3, errorText: 'please_enter_name'.tr),
]);

final heightValidator = MultiValidator([
  RequiredValidator(errorText: kEnterHeight),
]);

final weightValidator = MultiValidator([
  RequiredValidator(errorText: kEnterWeight),
]);

final firstNameValidator = MultiValidator([
  RequiredValidator(errorText: kEnterFirstName),
  MinLengthValidator(3, errorText: kEnterValidFirstName),
]);

final subjectValidator = MultiValidator([
  RequiredValidator(errorText: kEnterSubjectName),
  MinLengthValidator(3, errorText: kEnterValidSubjectName),
]);

final descriptionValidator = MultiValidator([
  RequiredValidator(errorText: kEnterDescriptionName),
  MinLengthValidator(3, errorText: kEnterValidDescriptionName),
]);

final lastNameValidator = MultiValidator([
  RequiredValidator(errorText: kEnterLastName),
  MinLengthValidator(3, errorText: kEnterValidLastName),
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'please_enter_email'.tr),
  EmailValidator(errorText: 'please_enter_valid_email'.tr),
]);

final discriptionIssueValidator = MultiValidator([
  RequiredValidator(errorText: kEnterDescription),
]);
/*final commonValidator = MultiValidator([
  LYDPhoneValidator(
    errorText: kEmptyField,
    emailInvalid: kEnterValidEmailAddress,
  ),
]);*/

const kEmptyField = 'Please enter email';
const kEnterDateOfBirth = 'Enter DOB';
const kEnterValidDateOfBirth = 'Enter valid DOB';

const kEnterCountryCode = 'Please enter country code';

const kEnterMobileNumber = 'Please enter mobile number';
const kEnterValidMobileNumber = 'Please enter valid mobile number';

const kEnterValidEmailAddress = 'Please enter valid email';
const kEnterEmailAddress = 'Please enter email';

const kEnterUserName = 'Please enter user name';
const kEnterValidUserName = 'Please enter at least 3 characters for user name';

const kEnterName = 'Please enter name';
const kEnterHeight = 'Enter height';
const kEnterWeight = 'Enter weight';

const kEnterFirstName = 'Please enter first name';
const kEnterValidFirstName =
    'Please enter at least 3 characters for first name';

const kEnterSubjectName = 'Please enter subject name';
const kEnterValidSubjectName =
    'Please enter at least 3 characters for subject name';

const kEnterDescriptionName = 'Please enter description name';
const kEnterValidDescriptionName =
    'Please enter at least 3 characters for description name';

const kEnterLastName = 'Please enter last name';
const kEnterValidLastName = 'Please enter at least 3 characters for last name';

const kEnterConfPassword = 'Please enter confirm password';
const kEnterPassword = 'Please enter password';
const kEnterValidPassword = 'Password should be 6 or more characters';

const kPleaseEnterOtp = 'Please enter OTP';
const kPleaseEnterValidOtp = 'Please enter valid OTP';

const kConfirm = "Confirm";
const kLogoutMsg = "Are you sure \n\nYou want to logout?";
const kDeleteAccount = "Are you sure \n\nYou want to delete account?";

const kEnterDescription = 'Please enter description';
