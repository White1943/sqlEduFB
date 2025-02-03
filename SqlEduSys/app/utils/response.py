from flask import jsonify

class ApiResponse:
    @staticmethod
    def success(data=None, message="Request was successful"):
        return jsonify({
            "status": "success",
            "message": message,
            "data": data
        }), 201

    @staticmethod
    def error(message="An error occurred", data=None, status_code=400):
        return jsonify({
            "status": "error",
            "message": message,
            "data": data
        }), status_code
