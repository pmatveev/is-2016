package ru.ifmo.is.ws;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;

import ru.ifmo.is.ws.util.WSResponse;

@WebService
@SOAPBinding(style = Style.RPC)
public interface Authentication {
	@WebMethod(operationName = "login")
	public WSResponse<String> login(
			@WebParam(name = "username") String username,
			@WebParam(name = "password") String password,
			@WebParam(name = "system") String systemName);

	@WebMethod(operationName = "logout")
	public WSResponse<Void> logout(
			@WebParam(name = "token") String token,
			@WebParam(name = "system") String systemName);
}
