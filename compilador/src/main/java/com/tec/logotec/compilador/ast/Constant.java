package com.tec.logotec.compilador.ast;

import java.util.Map;

public class Constant implements ASTNode {

	private Object object;
	
	
	
	
	public Constant(Object object) {
		super();
		this.object = object;
	}


	@Override
	public Object execute(Map<String, Object> symbolTable) {
		return object;
	}

}
