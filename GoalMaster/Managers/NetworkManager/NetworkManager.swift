import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = URL(string: "https://plansticker.site/app.php")!
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case serverError(String)
        case decodingError
    }
    
    func sendRequest<T: Decodable>(with body: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode,
                  let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                    completion(.failure(NetworkError.serverError(serverError.error)))
                } else {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
    
    struct ServerErrorResponse: Decodable {
        let error: String
    }
    
    struct SuccessResponse<T: Decodable>: Decodable {
        let success: String
        let task: T?
    }
    
    struct Task: Codable {
        let id: String?
        let title: String
        let date: String
        let category: String
        let priority: String
        let color: String
        let repeatField: String
        let time: String
        let isDone: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, title, date, category, priority, color, time, isDone
            case repeatField = "repeat"
        }
    }
    
    typealias TasksArray = [Task]
    typealias AllTasksResponse = [String: TasksArray]

    func register(username: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "metod": "register",
            "username": username,
            "email": email,
            "pass": password
        ]
        
        sendRequest(with: body) { (result: Result<SuccessResponse<Task>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "metod": "login",
            "username": username,
            "pass": password
        ]
        
        sendRequest(with: body) { (result: Result<SuccessResponse<Task>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setTaskForUser(username: String, task: Task, completion: @escaping (Result<Task, Error>) -> Void) {
        let taskDict: [String: Any] = [
            "title": task.title,
            "date": task.date,
            "category": task.category,
            "priority": task.priority,
            "color": task.color,
            "repeat": task.repeatField,
            "time": task.time,
            "isDone": task.isDone
        ]
        
        let body: [String: Any] = [
            "metod": "setTaskForUser",
            "username": username,
            "task": taskDict
        ]
        
        sendRequest(with: body) { (result: Result<SuccessResponse<Task>, Error>) in
            switch result {
            case .success(let response):
                if let task = response.task {
                    completion(.success(task))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTaskForUser(username: String, completion: @escaping (Result<TasksArray, Error>) -> Void) {
        let body: [String: Any] = [
            "metod": "getTaskForUser",
            "username": username
        ]
        
        sendRequest(with: body) { (result: Result<TasksArray, Error>) in
            completion(result)
        }
    }
    
    func getAllTasks(completion: @escaping (Result<AllTasksResponse, Error>) -> Void) {
        let body: [String: Any] = [
            "metod": "getAllTasks"
        ]
        
        sendRequest(with: body, completion: completion)
    }
    
    func logOut(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "metod": "logOut",
            "username": username,
            "pass": password
        ]
        
        sendRequest(with: body) { (result: Result<SuccessResponse<Task>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editTaskForUser(username: String, taskUpdates: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "metod": "editTaskForUser",
            "username": username,
            "task": taskUpdates
        ]
        
        sendRequest(with: body) { (result: Result<SuccessResponse<Task>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTaskForUser(username: String, taskId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let body: [String: Any] = [
            "metod": "deleteTaskForUser",
            "username": username,
            "taskId": taskId
        ]
        
        sendRequest(with: body) { (result: Result<SuccessResponse<Task>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
