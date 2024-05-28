import 'package:byme_flutter_app/utils/appointment/get_appointment.data.dart';
import 'package:byme_flutter_app/utils/patients/get_patients_data.dart';
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:byme_flutter_app/utils/user/get_user_data.dart';

Future<Map<String, dynamic>?> fetchUserData(String query, String date, search, order, state) async {
  try {
    final userStorage = await readToken();
    String token = userStorage?['token'];
    int doctorId = userStorage?['doctor_id'];

    final user = await getUserData(token, doctorId);
    final appointments = await getAppointmentsData(query, date);
    final patients = await getPatientsData(search, order, state);

    final data = {'user': user, 'appointments': appointments, 'patients': patients};

    return data;
  } catch (e) {
    throw 'Erro ao obter dados do utilizador: $e';
  }
}
