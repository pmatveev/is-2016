package ru.ifmo.is.ws.impl;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.ws.Authentication;
import ru.ifmo.is.ws.util.WSResponse;

@WebService(endpointInterface = "ru.ifmo.is.ws.Authentication")
public class AuthenticationImpl implements Authentication {
	@Override
	@WebMethod(operationName = "login")
	public WSResponse<String> login(
			@WebParam(name = "username") String username,
			@WebParam(name = "password") String password,
			@WebParam(name = "system") String systemName) {
		try {
			String token = new AuthenticationManager().authenticate(username,
					password, systemName);
			if (token == null || token.length() == 0) {
				return new WSResponse<String>("Wrong username or password", null);
			}
			return new WSResponse<String>(null, token);
		} catch (Throwable e) {
			return new WSResponse<String>(e.getMessage(), null);
		}
	}

	@Override
	@WebMethod(operationName = "logout")
	public WSResponse<Void> logout(
			@WebParam(name = "token") String token,
			@WebParam(name = "system") String systemName) {
		try {
			new AuthenticationManager().close(token, systemName);
			return new WSResponse<Void>();
		} catch (Throwable e) {
			return new WSResponse<Void>(e.getMessage(), null);			
		}
	}

}
