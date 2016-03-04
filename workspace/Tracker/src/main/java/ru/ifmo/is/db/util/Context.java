package ru.ifmo.is.db.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import ru.ifmo.is.db.config.DataConfig;

public class Context {
	private static final ApplicationContext context = new AnnotationConfigApplicationContext(DataConfig.class);
	
	static {
		try {
		} catch (Throwable e) {         
           // Log the exception. 
            System.err.println("Initial ApplicationContext creation failed");
            e.printStackTrace();
            throw new ExceptionInInitializerError(e); 
        }
	}
	
	public static ApplicationContext getContext() {
		return context;
	}
	
	public static Connection getConnection() throws SQLException {
		try {
			return ((DataSource) context.getBean("dataSource")).getConnection();
		} catch (BeansException e) {
			throw new SQLException(e);
		}
	}
}
