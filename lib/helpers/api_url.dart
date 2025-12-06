class ApiUrl {
  // IP Laptop kamu
  static const String baseUrl = 'http://192.168.1.16:8080'; 

  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  
  // Endpoint Buku
  static const String listBuku = baseUrl + '/buku';
  static const String createBuku = baseUrl + '/buku';

  static String updateBuku(int id) {
    return baseUrl + '/buku/' + id.toString();
  }
  static String showBuku(int id) {
    return baseUrl + '/buku/' + id.toString();
  }
  static String deleteBuku(int id) {
    return baseUrl + '/buku/' + id.toString();
  }
}