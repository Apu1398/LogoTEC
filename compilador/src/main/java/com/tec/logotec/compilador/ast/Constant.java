package com.tec.logotec.compilador.ast;

public class Constant implements ASTNode {

	private Object object;
	
	
	
	
	public Constant(Object object) {
		super();
		this.object = object;
	}


	@Override
	public Object execute(Context symbolTable) {
		return object;
	}

}
