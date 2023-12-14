import 'dart:convert';

import 'package:flutterapp/Common/constants.dart';
import 'package:flutterapp/Models/product.dart';
import 'package:flutterapp/Services/api_service.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final APIService _apiService = APIService();

  Future<Map<String, dynamic>> getProductsList(
      int page, String? searchValue, SortTypes? sortType) async {
    try {
      final Map<String, String> params = {
        "page": page.toString(),
        "limit": PAGE_LIMIT.toString()
      };
      if (searchValue != null) params["productName"] = searchValue;
      if (sortType != null) {
        params["sortType"] = sortType.toString().split('.').last;
      }

      final http.Response response = await _apiService.get("/products", params);
      final dynamic responseJson = jsonDecode(response.body);

      final productsData = responseJson['data']['content'] as List;
      final List<Product> productsList =
      productsData.map((json) => Product.fromJson(json)).toList();

      final pagesData = responseJson['data']['totalPages'];
      final Map<String, dynamic> returnedData = {
        "productsList": productsList,
        "pagesNumber": pagesData
      };
      return returnedData;
    } catch (e) {
      // Handle exceptions - log or throw an appropriate error.
      print("Error fetching products: $e");
      rethrow; // Propagate the error up the stack.
    }
  }

  Future<Product> _sendProductRequest(String endpoint, Product product) async {
    try {
      final http.Response response =
      await _apiService.post(endpoint, product.toJson(product));
      final dynamic responseJson = jsonDecode(response.body);
      final jsonData = responseJson['data'];
      final Product updatedProduct = Product.fromJson(jsonData);
      return updatedProduct;
    } catch (e) {
      // Handle exceptions - log or throw an appropriate error.
      print("Error with product request: $e");
      rethrow; // Propagate the error up the stack.
    }
  }

  Future<Product> addProduct(Product product) async {
    return await _sendProductRequest("/products/add", product);
  }

  Future<Product> editProduct(Product product) async {
    return await _sendProductRequest("/products/edit", product);
  }

  Future<void> deleteProduct(Product product) async {
    try {
      final http.Response response =
      await _apiService.delete("/products/delete/${product.id}");
      final dynamic responseJson = jsonDecode(response.body);
      final jsonMessage = responseJson['message'];
      print("Message after deleting: $jsonMessage");
    } catch (e) {
      // Handle exceptions - log or throw an appropriate error.
      print("Error deleting product: $e");
      rethrow; // Propagate the error up the stack.
    }
  }
}


// class ProductRepository {
//   final APIService _apiService = APIService();
//
//   Future<Map<String, dynamic>> getProductsList(
//       int page, String? searchValue, SortTypes? sortType) async {
//     Map<String, String> params = {
//       "page": page.toString(),
//       "limit": PAGE_LIMIT.toString()
//     };
//     if (searchValue != null) params["productName"] = searchValue;
//     if (sortType != null) {
//       params["sortType"] = sortType.toString().split('.').last;
//     }
//     http.Response response = await _apiService.get("/products", params);
//     dynamic responseJson = jsonDecode(response.body);
//     final productsData = responseJson['data']['content'] as List;
//     List<Product> productsList =
//         productsData.map((json) => Product.fromJson(json)).toList();
//     final pagesData = responseJson['data']['totalPages'];
//     Map<String, dynamic> returnedData = {
//       "products list": productsList,
//       "pages number": pagesData
//     };
//     return returnedData;
//   }
//
//   Future<Product> addProduct(Product product) async {
//     http.Response response =
//         await _apiService.post("/products/add", product.toJson(product));
//     dynamic responseJson = jsonDecode(response.body);
//     final jsonData = responseJson['data'];
//     Product savedProduct = Product.fromJson(jsonData);
//     return savedProduct;
//   }
//
//   Future<Product> editProduct(Product product) async {
//     http.Response response =
//         await _apiService.put("/products/edit", product.toJson(product));
//     dynamic responseJson = jsonDecode(response.body);
//     final jsonData = responseJson['data'];
//     Product editedProduct = Product.fromJson(jsonData);
//     return editedProduct;
//   }
//
//   Future<dynamic> deleteProduct(Product product) async {
//     http.Response response =
//         await _apiService.delete("/products/delete/${product.id}");
//     dynamic responseJson = jsonDecode(response.body);
//     final jsonMessage = responseJson['message'];
//   }
// }
