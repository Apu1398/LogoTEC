package com.tec.logotec.compilador.ast;

import java.util.List;

public class Conditional implements ASTNode {

	private ASTNode condition;
	private List<ASTNode> ifBody;
	private List<ASTNode> elseBody;
	
	
	
	public Conditional(ASTNode condition, List<ASTNode> ifBody, List<ASTNode> elseBody) {
		super();
		this.condition = condition;
		this.ifBody = ifBody;
		this.elseBody = elseBody;
	}



	@Override
	public Object execute() {
		if((boolean)condition.execute()) {
			for (ASTNode statement : ifBody) {
				statement.execute();
			}
		}else {
			for (ASTNode statement : elseBody) {
				statement.execute();
			}
		}
		return null;
	}

}
