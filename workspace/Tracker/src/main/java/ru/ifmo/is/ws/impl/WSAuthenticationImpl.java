package ru.ifmo.is.ws.impl;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

import ru.ifmo.is.manager.AuthenticationManager;
import ru.ifmo.is.manager.util.AuthenticationInfo;
import ru.ifmo.is.ws.WSAuthentication;
import ru.ifmo.is.ws.util.ConnectionInfo;
import ru.ifmo.is.ws.util.WSResponse;

@WebService(endpointInterface = "ru.ifmo.is.ws.WSAuthentication")
public class WSAuthenticationImpl implements WSAuthentication {
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
			@WebParam(name = "connection") ConnectionInfo connection) {
		try {
			new AuthenticationManager().close(connection.getToken(), connection.getSystem());
			return new WSResponse<Void>();
		} catch (Throwable e) {
			return new WSResponse<Void>(e.getMessage(), null);			
		}
	}

	@Override
	@WebMethod(operationName = "connectionDetails")
	public WSResponse<AuthenticationInfo> verify(
			@WebParam(name = "connection") ConnectionInfo connection) {
		try {
			return new WSResponse<AuthenticationInfo>(null,
					new AuthenticationManager().verify(connection.getToken(),
							connection.getSystem()));
		} catch (Throwable e) {
			return new WSResponse<AuthenticationInfo>(e.getMessage(), null);
		}
	}

}
